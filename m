Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0B45366
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfFNEVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:21:34 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44844 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNEVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 00:21:34 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so2794530iob.11;
        Thu, 13 Jun 2019 21:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3+KBmj31ClVjX71bsDs+QcXX1G/+iWLc2qTxdgMVAKo=;
        b=ESZgn29rlDftf4aUhW3dIASJNsu+/kRnAPGSPcXAvvOzD+bUushNchOr9XSZj/sTYU
         oAVmKO0E7X6PpEgUHQQTyjfN+Xu/U6ZdSj5JN3M0t6RWBjM2UW4f6BvAnbkE3vxfu0DF
         b0krGPfAM5EmtFPK0yPSrTNCcBIlwCsGo5jYvSonqHq83j1kONGP0NrRtvuH2tVx6wwF
         /F8SyXrah59a4cBh75dWA9m4DaC/5kYTUSXfvj2qYpwBx4VrxifxtpGWvDLtAxsnRgMh
         KkOO51PZ9x3u0kea1y6OKrprFmtCdNMp8P/XFRBIjEv1TPIUqJKrtw4kIfYlpgwzBGvW
         qcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3+KBmj31ClVjX71bsDs+QcXX1G/+iWLc2qTxdgMVAKo=;
        b=Uxrx6uU/4Jy2nmBAi4+kqX4nIH8cVA26BKjY644psp62WncWGIVqJ5TsNG30xrq9mL
         Jk6JLj0xs0dmZ6tJ0iay3C4TI4DPYZbYmEJCeC7qSyD32cFWr5Snlc4QTUD7xkiqjo0B
         xId9h1jb9qsjiD+AU7okyiACHHLJ50jIsLo8tS6rjrnjX66wRzGmdPKzIO1skTRUAj9+
         h0NqKndH2zlBNUbj/wDQh/UbCOH+L5a7l9KTGnpTH1BI9SV4K7y/39KMy99zjMv1xKFD
         w68UVkoD6+JparXH+IvnEOPU4kMUrb/SrZozlY8T7AI6LQ0jjJagttmSlk5wFFh/Bdv5
         XJxQ==
X-Gm-Message-State: APjAAAW4i8Gom/0bIQa0OVo6Z7TooeLJnM8VDleGjWuI6vbYZFs675nc
        R3wI/Mz3UYVhcEmd1l17zZM=
X-Google-Smtp-Source: APXvYqy1xcfgGfZOD2VdB9q/wCTRnL1fXRDmgUfgbukokwyNO/t3q6PJIcqz8ML1TsaR+kar2OBofA==
X-Received: by 2002:a6b:5815:: with SMTP id m21mr1642385iob.171.1560486093198;
        Thu, 13 Jun 2019 21:21:33 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m25sm1289316ion.35.2019.06.13.21.21.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 21:21:32 -0700 (PDT)
Date:   Thu, 13 Jun 2019 21:21:25 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hillf Danton <hdanton@sina.com>, Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>,
        "aviadye@mellanox.com" <aviadye@mellanox.com>,
        "borisp@mellanox.com" <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Message-ID: <5d0320c540981_5ab92b1f436fc5c45b@john-XPS-13-9370.notmuch>
In-Reply-To: <20190612045828.10212-1-hdanton@sina.com>
References: <20190612045828.10212-1-hdanton@sina.com>
Subject: Re: memory leak in create_ctx
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton wrote:
> 
> Hi Dmitry
> 
> On Tue, 11 Jun 2019 19:45:28 +0800 Dmitry Vyukov wrote:
> >
> > I've run the repro as "./syz-execprog -repeat=0 -procs=6 repro"  and
> > in 10 mins I got the following splat, which indeed suggests a bpf bug.
> > But we of course can have both bpf stack overflow and a memory leak in tls.
> >
> >
> >
> > 2019/06/11 10:26:52 executed programs: 887
> > 2019/06/11 10:26:57 executed programs: 899
> > 2019/06/11 10:27:02 executed programs: 916
> > [  429.171049][ T9870] BUG: stack guard page was hit at 00000000a78467b9 (stack is 000000001452e9df..000000004fb93e51)
> > [  429.173714][ T9870] kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP
> > [  429.174819][ T9870] CPU: 3 PID: 9870 Comm: syz-executor Not tainted 5.2.0-rc4+ #6
> > [  429.175901][ T9870] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> > [  429.177215][ T9870] RIP: 0010:tcp_bpf_unhash+0xc/0x80
> > [  429.177950][ T9870] Code: 28 4c 89 ee 48 89 df ff 10 e8 30 56 66 fe
> > 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41
> > 54 53 48 89 fb <e8> 0f 56 66 fe e8 6a bb 5f fe 4c 8b a3 80 02 00 00 4d
> > 85 e4 74 2f
> > [  429.180707][ T9870] RSP: 0018:ffffc90003690000 EFLAGS: 00010293
> > [  429.181562][ T9870] RAX: ffff888066a72000 RBX: ffff88806695b640 RCX: ffffffff82c82f80
> > [  429.182681][ T9870] RDX: 0000000000000000 RSI: 0000000000000007 RDI: ffff88806695b640
> > [  429.183807][ T9870] RBP: ffffc90003690018 R08: 0000000000000000 R09: 0000000000000000
> > [  429.184931][ T9870] R10: ffffc90003693e70 R11: 0000000000000000 R12: ffffffff82c82f10
> > [  429.186104][ T9870] R13: 0000000000000007 R14: ffff88806695b710 R15: ffff88806695b710
> > [  429.187303][ T9870] FS:  00005555569fc940(0000) GS:ffff88807db80000(0000) knlGS:0000000000000000
> > [  429.188678][ T9870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  429.189674][ T9870] CR2: ffffc9000368fff8 CR3: 00000000762bc002 CR4: 00000000007606e0
> > [  429.190880][ T9870] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  429.192094][ T9870] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  429.193295][ T9870] PKRU: 55555554
> > [  429.193829][ T9870] Call Trace:
> > [  429.194326][ T9870]  ? tcp_bpf_close+0xa0/0xa0
> > [  429.195020][ T9870]  tcp_bpf_unhash+0x76/0x80
> > [  429.195706][ T9870]  ? tcp_bpf_close+0xa0/0xa0
> > [  429.196400][ T9870]  tcp_bpf_unhash+0x76/0x80
> > [  429.197079][ T9870]  ? tcp_bpf_close+0xa0/0xa0
> > [  429.197773][ T9870]  tcp_bpf_unhash+0x76/0x80
> > [  429.651942][ T9870]  ? tcp_bpf_close+0xa0/0xa0
> >
> ... duplicated info trimed ...
> >
> > [  429.652512][ T9870]  tcp_bpf_unhash+0x76/0x80
> > [  429.656467][ T9870]  ? tcp_bpf_close+0xa0/0xa0
> > [  429.657037][ T9870]  tcp_bpf_unhash+0x76/0x80
> > [  429.657600][ T9870]  tcp_set_state+0x7b/0x220
> > [  429.658160][ T9870]  ? put_object+0x20/0x30
> > [  429.658699][ T9870]  ? debug_smp_processor_id+0x2b/0x130
> > [  429.659382][ T9870]  tcp_disconnect+0x518/0x610
> > [  429.659973][ T9870]  tcp_close+0x41d/0x540
> > [  429.660501][ T9870]  ? tcp_check_oom+0x180/0x180
> > [  429.661095][ T9870]  tls_sk_proto_close+0x86/0x2a0
> > [  429.661711][ T9870]  ? locks_remove_posix+0x114/0x1c0
> > [  429.662359][ T9870]  inet_release+0x44/0x80
> > [  429.662899][ T9870]  inet6_release+0x36/0x50
> > [  429.663453][ T9870]  __sock_release+0x4b/0x100
> > [  429.664024][ T9870]  ? __sock_release+0x100/0x100
> > [  429.664625][ T9870]  sock_close+0x19/0x20
> > [  429.665141][ T9870]  __fput+0xe7/0x2f0
> > [  429.665624][ T9870]  ____fput+0x15/0x20
> > [  429.666120][ T9870]  task_work_run+0xa4/0xd0
> > [  429.666671][ T9870]  exit_to_usermode_loop+0x16f/0x180
> > [  429.667329][ T9870]  do_syscall_64+0x187/0x1b0
> > [  429.667920][ T9870]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [  429.668654][ T9870] RIP: 0033:0x412451
> > [  429.669141][ T9870] Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff
> > ff 0f 83 94 1a 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03
> > 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4
> > 08 48 3d 01
> > [  429.671586][ T9870] RSP: 002b:00007ffde18b5470 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> > [  429.672636][ T9870] RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000412451
> > [  429.673628][ T9870] RDX: 0000000000000000 RSI: 0000000000000081 RDI: 0000000000000004
> > [  429.674643][ T9870] RBP: 0000000000000000 R08: 0000000000721170 R09: 0000000000000000
> > [  429.675641][ T9870] R10: 00007ffde18b5580 R11: 0000000000000293 R12: 0000000000000000
> > [  429.676636][ T9870] R13: 000000000071bf00 R14: 00000000006e3140 R15: ffffffffffffffff
> > [  429.677630][ T9870] Modules linked in:
> > [  429.678119][ T9870] ---[ end trace a429c7ce256ca7bb ]---
> > [  429.678798][ T9870] RIP: 0010:tcp_bpf_unhash+0xc/0x80
> > [  429.679447][ T9870] Code: 28 4c 89 ee 48 89 df ff 10 e8 30 56 66 fe
> > 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41
> > 54 53 48 89 fb <e8> 0f 56 66 fe e8 6a bb 5f fe 4c 8b a3 80 02 00 00 4d
> > 85 e4 74 2f
> > [  429.681882][ T9870] RSP: 0018:ffffc90003690000 EFLAGS: 00010293
> > [  429.682637][ T9870] RAX: ffff888066a72000 RBX: ffff88806695b640 RCX: ffffffff82c82f80
> > [  429.683630][ T9870] RDX: 0000000000000000 RSI: 0000000000000007 RDI: ffff88806695b640
> > [  429.684622][ T9870] RBP: ffffc90003690018 R08: 0000000000000000 R09: 0000000000000000
> > [  429.685611][ T9870] R10: ffffc90003693e70 R11: 0000000000000000 R12: ffffffff82c82f10
> > [  429.686601][ T9870] R13: 0000000000000007 R14: ffff88806695b710 R15: ffff88806695b710
> > [  429.687592][ T9870] FS:  00005555569fc940(0000) GS:ffff88807db80000(0000) knlGS:0000000000000000
> > [  429.688701][ T9870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  429.689519][ T9870] CR2: ffffc9000368fff8 CR3: 00000000762bc002 CR4: 00000000007606e0
> > [  429.690511][ T9870] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  429.691507][ T9870] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  429.692502][ T9870] PKRU: 55555554
> > [  429.692941][ T9870] Kernel panic - not syncing: Fatal exception
> > [  429.694377][ T9870] Kernel Offset: disabled
> > [  429.694913][ T9870] Rebooting in 86400 seconds..
> >
> >
> In case of short circuit, bail out after warning on the unusual event to advoid
> spiraling down the stack without brakes.

Thanks for tracking this down, I was able to reproduce with sys-execprog
so will try and come up with some fix.

We really shouldn't ever get here, somehow we dropped the psock but left
the sk_prot hooked up. At this point just returning is going to leave
lots of psock/tls/sock state floating around.

I guess we need to find the case where sk_prot is not reset.

.John

> 
> Thanks
> Hillf
> ---
>  net/ipv4/tcp_bpf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 3d1e154..5022cd3 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -546,6 +546,8 @@ static void tcp_bpf_unhash(struct sock *sk)
>  	psock = sk_psock(sk);
>  	if (unlikely(!psock)) {
>  		rcu_read_unlock();
> +		if (WARN_ON(sk->sk_prot->unhash == tcp_bpf_unhash))
> +			return;
>  		if (sk->sk_prot->unhash)
>  			sk->sk_prot->unhash(sk);
>  		return;
> @@ -568,6 +570,8 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
>  	if (unlikely(!psock)) {
>  		rcu_read_unlock();
>  		release_sock(sk);
> +		if (WARN_ON(sk->sk_prot->close == tcp_bpf_close))
> +			return;
>  		return sk->sk_prot->close(sk, timeout);
>  	}
> 
> --
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD238BF82
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfHMRRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:17:17 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35547 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfHMRRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:17:17 -0400
Received: by mail-ot1-f67.google.com with SMTP id g17so24457126otl.2;
        Tue, 13 Aug 2019 10:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NGLe9R6TH0gA90LodsbIsArKREL2u+B16+/2nJh97c0=;
        b=gJBMgCy7nt3IeZMNu2hBgVLvhtgwuryD2slw94jAVFQLR855zVUPI3SVTD8vdegQq3
         lJASni0EAd20uPZVN+s8xhTXSXySFAeklSClTk9oIfAwS+KhP7ak88rCFMtgkoavI9JV
         G/rU/KBnKpnYWUZkyEK/tzlbMYFUXZwilL9E40y9EXjIeTNsPMI3TCf2RkIdvzDxxDpO
         yIC69Ng2VVeEd2BqIpIxeGIfyKk/gTWJiVANzgTe9e0Vh2V9zH9vlwRuwEWCzBo/Pr33
         hamiGZWdiYbSb0hdRKsnI66yLBLExsWnPZRpLIfcUc3X8HMmG63rBnta3X5UqGwwgm8U
         tciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NGLe9R6TH0gA90LodsbIsArKREL2u+B16+/2nJh97c0=;
        b=HzOSfrpRb7imUkLPozFA4cluauHUBP0aJPxjyUqoPCUYcxUoCej6pVC4+/yLozWEBw
         YgU7b+X+9kIPj85jTgHQ7zL7mJka/uqv6IZyB6QcE58ROou2t1y2sDUPk5h8JWI7jnM0
         lxlKU1MVVCWhg28K+Ze2YWYaHBoujkLOITCT9nMspaqDWyLCl3peBzzMh/Z2yXMwLo8U
         Ge8I73zpFYENpkN/47vl6hcwUANvsLYxl7m3PtruxPwYQV+C0+n4D+jIKVk/CdO6JFyC
         nATFfY+DmOVRMQ3FfQcYplErRgyPzGC3eWdaZYp08/lJn0ON+nEZ3Ta0xSAl2G30Y2i+
         LpKQ==
X-Gm-Message-State: APjAAAX8fEcUk1eZ9s7513Y0R33rapdkjh2KMLhKRl7M3U0nMhwPBCpH
        rTw3JYpmnDtqDnqsavmX+YI=
X-Google-Smtp-Source: APXvYqy1K9u54o25aGY1RYmHvPMcG4xIhnKq66m5aq1oMVKhWqOfdXnCWA7rxZGNCZ9U3vrrmsIXBg==
X-Received: by 2002:a6b:5a0b:: with SMTP id o11mr3445697iob.98.1565716635498;
        Tue, 13 Aug 2019 10:17:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v10sm101031303iob.43.2019.08.13.10.17.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 10:17:14 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:17:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, syzkaller-bugs@googlegroups.com,
        willemb@google.com
Message-ID: <5d52f09299e91_40c72adb748b25c0d3@john-XPS-13-9370.notmuch>
In-Reply-To: <20190810135900.2820-1-hdanton@sina.com>
References: <000000000000f5d619058faea744@google.com>
 <20190810135900.2820-1-hdanton@sina.com>
Subject: Re: general protection fault in tls_write_space
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
> On Sat, 10 Aug 2019 01:23:06 -0700
> > 
> > syzbot has found a reproducer for the following crash on:
> > 
> > HEAD commit:    ca497fb6 taprio: remove unused variable 'entry_list_policy'
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=109f3802600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=dcdc9deefaec44785f32
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c78cd2600000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
> > 
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.3.0-rc3+ #125
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> > Google 01/01/2011
> > RIP: 0010:tls_write_space+0x51/0x170 net/tls/tls_main.c:239
> > Code: c1 ea 03 80 3c 02 00 0f 85 26 01 00 00 49 8b 9c 24 b0 06 00 00 48 b8  
> > 00 00 00 00 00 fc ff df 48 8d 7b 6a 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
> > 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 df 00 00 00
> > RSP: 0018:ffff8880a98b74c8 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff860a27a2
> > RDX: 000000000000000d RSI: ffffffff862c86c1 RDI: 000000000000006a
> > RBP: ffff8880a98b74e0 R08: ffff8880a98a2240 R09: fffffbfff167c289
> > R10: fffffbfff167c288 R11: ffffffff8b3e1447 R12: ffff8880a4de41c0
> > R13: ffff8880a4de45b8 R14: 000000000000000a R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 000000008c9d1000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   tcp_new_space net/ipv4/tcp_input.c:5151 [inline]
> >   tcp_check_space+0x191/0x760 net/ipv4/tcp_input.c:5162
> >   tcp_data_snd_check net/ipv4/tcp_input.c:5172 [inline]
> >   tcp_rcv_state_process+0xe24/0x4e48 net/ipv4/tcp_input.c:6303
> >   tcp_v6_do_rcv+0x7d7/0x12c0 net/ipv6/tcp_ipv6.c:1381
> >   tcp_v6_rcv+0x31f1/0x3500 net/ipv6/tcp_ipv6.c:1588
> >   ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
> >   ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
> >   NF_HOOK include/linux/netfilter.h:305 [inline]
> >   NF_HOOK include/linux/netfilter.h:299 [inline]
> >   ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
> >   dst_input include/net/dst.h:442 [inline]
> >   ip6_rcv_finish+0x1de/0x2f0 net/ipv6/ip6_input.c:76
> >   NF_HOOK include/linux/netfilter.h:305 [inline]
> >   NF_HOOK include/linux/netfilter.h:299 [inline]
> >   ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
> >   __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5006
> >   __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5120
> >   process_backlog+0x206/0x750 net/core/dev.c:5951
> >   napi_poll net/core/dev.c:6388 [inline]
> >   net_rx_action+0x4d6/0x1080 net/core/dev.c:6456
> >   __do_softirq+0x262/0x98c kernel/softirq.c:292
> >   run_ksoftirqd kernel/softirq.c:603 [inline]
> >   run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
> >   smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
> >   kthread+0x361/0x430 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Modules linked in:
> > ---[ end trace c21a83505707bb9d ]---
> 
> Followup of commit 95fa145479fb
> ("bpf: sockmap/tls, close can race with map free")
> 
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -308,6 +308,9 @@ static void tls_sk_proto_close(struct so
>  	if (free_ctx)
>  		icsk->icsk_ulp_data = NULL;
>  	sk->sk_prot = ctx->sk_proto;
> +	/* tls will go; restore sock callback before enabling bh */
> +	if (sk->sk_write_space == tls_write_space)
> +		sk->sk_write_space = ctx->sk_write_space;
>  	write_unlock_bh(&sk->sk_callback_lock);
>  	release_sock(sk);
>  	if (ctx->tx_conf == TLS_SW)

Hi Hillf,

We need this patch (although slightly updated for bpf tree) do
you want to send it? Otherwise I can. We should only set this if
TX path was enabled otherwise we null it. Checking against
tls_write_space seems best to me as well.

Against bpf this patch should fix it.

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ce6ef56a65ef..43252a801c3f 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -308,7 +308,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
        if (free_ctx)
                icsk->icsk_ulp_data = NULL;
        sk->sk_prot = ctx->sk_proto;
-       sk->sk_write_space = ctx->sk_write_space;
+       if (sk->sk_write_space == tls_write_space)
+               sk->sk_write_space = ctx->sk_write_space;
        write_unlock_bh(&sk->sk_callback_lock);
        release_sock(sk);
        if (ctx->tx_conf == TLS_SW)

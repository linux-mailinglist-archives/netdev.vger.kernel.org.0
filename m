Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04CD8F85D
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfHPBLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:11:47 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45940 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHPBLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:11:46 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so3392985qki.12
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 18:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Rbq2eJ7KZq0RzLXpjgW/ZcfZFRzoMUskGtK7fK2K5/g=;
        b=CZaii7gcMhA9ZeQo9LX9swlMehFen1b/QndvEsnqnWrH9arEWtW09Gi5GDXTBU17kE
         vj8vpWBKMc6riL+e1obdBk8//rCKbi5Psxxyb7J5FoGLrq1aYXCAJVnaX36Ks7ySzRAi
         Q5V2uYIdiI3c2J6WujNycfK60lb66/CMRsyLNIUlkDfo2AoZg+hZpdUdGzo2/wIfckIg
         bv4QnCDyNMgwtmvM+EmwCfooU3m0ttGdywy2HjakjLDog9f4Bn0sT6xqVG/m9cvux8em
         E+fJoHd7BPzlJdhVwdlMwokV9L7MFEKymsP+3o6gXpnKll2IsX3x+kiFJRVgRXWFLFaf
         obNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Rbq2eJ7KZq0RzLXpjgW/ZcfZFRzoMUskGtK7fK2K5/g=;
        b=IQD/xIWen5EMb9PWxqMJ+y5+SiHm8QaJNm9rFsr8QEPobr8k80nkl1scy4oOIlWqi0
         LXFq+glid57GGwfjxl4PLJ3HDm+PMOhm1KQQBAO7qRtFNuGcPJLxm3MUBBvyO/n1phiF
         ajSGsXgQKvTPqMxbX25cheqPvBiKa/zdWIu7HaSCFKH56rAl3FXbifinfw2KTxNo8hG0
         DKfDS6AuiDSd+pFaoFaJWaz/IULIw0PYN9jUjugH6fwHo4h5GFZZEV/jTcH9z/OqIaAn
         5Osu6E8Gupy/FGdMvowswYPEV3AmSxJqb2UPVO2i+Hx0xKKv/65R24sQQAIf85xAYBCB
         CC+A==
X-Gm-Message-State: APjAAAWV9lSiotLKOjVUkMukiJXpE4pwcGlJwzW87mN0VEoEhKfIBpt5
        GDgc3OGf+hXBE4/oikrnYyHM1w==
X-Google-Smtp-Source: APXvYqzK0n1SoR2Vc+r61iNqCltlb6bI/Y1APffNLbi25Uh59bRhBAhSvbGXuecmywiutAgoXpK1LA==
X-Received: by 2002:a05:620a:691:: with SMTP id f17mr6883617qkh.470.1565917905610;
        Thu, 15 Aug 2019 18:11:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v81sm2390151qkb.21.2019.08.15.18.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 18:11:45 -0700 (PDT)
Date:   Thu, 15 Aug 2019 18:11:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: INFO: task hung in tls_sw_release_resources_tx
Message-ID: <20190815181129.561cef8f@cakuba.netronome.com>
In-Reply-To: <20190815141419.15036-1-hdanton@sina.com>
References: <20190815141419.15036-1-hdanton@sina.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 22:14:19 +0800, Hillf Danton wrote:
> On Thu, 15 Aug 2019 03:54:06 -0700
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    6d5afe20 sctp: fix memleak in sctp_send_reset_streams
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16e5536a600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6a9ff159672dfbb41c95
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cb0502600000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d5dc22600000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com
> > 
> > INFO: task syz-executor153:10198 blocked for more than 143 seconds.
> >        Not tainted 5.3.0-rc3+ #162
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > syz-executor153 D27672 10198  10179 0x80000002
> > Call Trace:
> >   context_switch kernel/sched/core.c:3254 [inline]
> >   __schedule+0x755/0x1580 kernel/sched/core.c:3880
> >   schedule+0xa8/0x270 kernel/sched/core.c:3944
> >   schedule_timeout+0x717/0xc50 kernel/time/timer.c:1783
> >   do_wait_for_common kernel/sched/completion.c:83 [inline]
> >   __wait_for_common kernel/sched/completion.c:104 [inline]
> >   wait_for_common kernel/sched/completion.c:115 [inline]
> >   wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
> >   crypto_wait_req include/linux/crypto.h:685 [inline]
> >   crypto_wait_req include/linux/crypto.h:680 [inline]
> >   tls_sw_release_resources_tx+0x4ee/0x6b0 net/tls/tls_sw.c:2075
> >   tls_sk_proto_cleanup net/tls/tls_main.c:275 [inline]
> >   tls_sk_proto_close+0x686/0x970 net/tls/tls_main.c:305
> >   inet_release+0xed/0x200 net/ipv4/af_inet.c:427
> >   inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
> >   __sock_release+0xce/0x280 net/socket.c:590
> >   sock_close+0x1e/0x30 net/socket.c:1268
> >   __fput+0x2ff/0x890 fs/file_table.c:280
> >   ____fput+0x16/0x20 fs/file_table.c:313
> >   task_work_run+0x145/0x1c0 kernel/task_work.c:113
> >   exit_task_work include/linux/task_work.h:22 [inline]
> >   do_exit+0x92f/0x2e50 kernel/exit.c:879
> >   do_group_exit+0x135/0x360 kernel/exit.c:983
> >   __do_sys_exit_group kernel/exit.c:994 [inline]
> >   __se_sys_exit_group kernel/exit.c:992 [inline]
> >   __x64_sys_exit_group+0x44/0x50 kernel/exit.c:992
> >   do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x43ff88
> > Code: 00 00 be 3c 00 00 00 eb 19 66 0f 1f 84 00 00 00 00 00 48 89 d7 89 f0  
> > 0f 05 48 3d 00 f0 ff ff 77 21 f4 48 89 d7 44 89 c0 0f 05 <48> 3d 00 f0 ff  
> > ff 76 e0 f7 d8 64 41 89 01 eb d8 0f 1f 84 00 00 00
> > RSP: 002b:00007ffd1c2d0f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ff88
> > RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> > RBP: 00000000004bf890 R08: 00000000000000e7 R09: ffffffffffffffd0
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> > R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
> > INFO: lockdep is turned off.
> > NMI backtrace for cpu 0
> > CPU: 0 PID: 1057 Comm: khungtaskd Not tainted 5.3.0-rc3+ #162
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> > Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> >   nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
> >   nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
> >   arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
> >   trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
> >   check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
> >   watchdog+0x9d0/0xef0 kernel/hung_task.c:289
> >   kthread+0x361/0x430 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Sending NMI from CPU 0 to CPUs 1:
> > NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10  
> > arch/x86/include/asm/irqflags.h:60  
> 
> 1, diff -> commit f87e62d45e51 -> commit 1023121375c6
> 
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2167,11 +2167,13 @@ static void tx_work_handler(struct work_
>  		return;
>  
>  	ctx = tls_sw_ctx_tx(tls_ctx);
> -	if (test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
> -		return;
> -
> -	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
> -		return;
> +	if (test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask)) {
> +		if (!test_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
> +			return;
> +	} else {
> +		if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
> +			return;
> +	}
>  	lock_sock(sk);
>  	tls_tx_records(sk, -1);
>  	release_sock(sk);
> --
> 
> 2, a simpler one. And clear BIT_TX_SCHEDULED perhaps after releasing sock.
> 
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2167,11 +2167,9 @@ static void tx_work_handler(struct work_
>  		return;
>  
>  	ctx = tls_sw_ctx_tx(tls_ctx);
> -	if (test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
> -		return;
> +	if (!test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
> +		clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask);
>  
> -	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
> -		return;
>  	lock_sock(sk);
>  	tls_tx_records(sk, -1);
>  	release_sock(sk);

Mmm.. too terse, I don't follow what you're trying to do here :(

I've been staring at this for a while and trying to repo but it's not
happening here.

The only thing I see is that EBUSY is not handled.

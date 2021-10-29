Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B084E43FFF9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhJ2QCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhJ2QCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:02:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882CDC061570;
        Fri, 29 Oct 2021 08:59:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so10930112pjl.2;
        Fri, 29 Oct 2021 08:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4J0f3I4/OLkY/4Cq2seEvAuUDSEmYpImIIwQkyEpMhc=;
        b=AnQOIqezjdc4OMFIQP73+sf5pBmVwVZ5pne92AWkSQvW0Cijq9EDGUm2xmVbKs4re0
         V3gcwCcC+3pRQmbvnimOaAdeT+jYioeVJCZ36Ev2CL93JltCrAQAGovHMartTDUD+Cia
         tfDge76in0AAR8yUmrvspGEuXeozC/ordG5MYUT0DBTF77ChSDdc3CgqPZs7/opEJSZD
         q8S5mi5Z4c3INcU3vs6nY528aD858SGBSLqUqgyeXOAMq7FsswO1efSRCsUbpXniOyJa
         PQb35/LEfo/vrkBLTsRpl7aImbH+0oBikdpRqxjKd+aX0B5anR9CBXoMav/RPH5WicNf
         njyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4J0f3I4/OLkY/4Cq2seEvAuUDSEmYpImIIwQkyEpMhc=;
        b=IheO6lr9vLSDuADboNcwVEfSjX5HsSZ0Gd/a4rYupfx90edU7sYSNfW9uojHZuJs71
         ZhH3Gs6jlcr1N5OXd2jbX2yDP+z6kQ/V692rgQyUhIjmwXPg/h3KUBloDjwVUj0nF6hL
         f05Xutn7CweryVvtYXQjRc4fLHsL2ioqEGBtzmaQB3M4+zJTi1AoKojBjuzrkIwJDdSB
         uLs1GL8FWkpNs+/jS99JIo0ESFSCxYoAZ8WX4a3EKFXI0uphRLeoaHq04zH5CJI2Domj
         DjOD3LCw+icAQy8M3yBWiyJBqAYbvwRfAPvtM/Jkxth5mxKdkuBMLsDtlBJjYC3ROrb8
         ohRw==
X-Gm-Message-State: AOAM532IM9YAygOqsAbL1GdjJtbKstoxWeaog6PRb9u7szdMkDceBxPW
        +rNCR1qQSfJl8+iO7fFlppc=
X-Google-Smtp-Source: ABdhPJxqOSz98FNZCUCMHupv13OuFBErruu850/i3nrcdkOl9KC+O4+qrcy8jbiEJu8AAD67L3tUHA==
X-Received: by 2002:a17:90b:3149:: with SMTP id ip9mr18204273pjb.45.1635523186936;
        Fri, 29 Oct 2021 08:59:46 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id rj2sm7026140pjb.32.2021.10.29.08.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 08:59:45 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in fq_codel_enqueue (3)
To:     syzbot <syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <000000000000c3a2af05cf7fda31@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <67075233-6110-dd44-c69f-eddc2e6f3d82@gmail.com>
Date:   Fri, 29 Oct 2021 08:59:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <000000000000c3a2af05cf7fda31@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/21 8:55 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1fc596a56b33 Merge tag 'trace-v5.15-rc6' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1453dc04b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b160d0631c7a8f26
> dashboard link: https://syzkaller.appspot.com/bug?extid=7a12909485b94426aceb
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154a0b64b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177eec86b00000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=154fc86ab00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=174fc86ab00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=134fc86ab00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 6542 Comm: syz-executor965 Not tainted 5.15.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:dequeue_head net/sched/sch_fq_codel.c:120 [inline]
> RIP: 0010:fq_codel_drop net/sched/sch_fq_codel.c:168 [inline]
> RIP: 0010:fq_codel_enqueue+0x83e/0x10c0 net/sched/sch_fq_codel.c:230
> Code: f8 e2 25 fa 45 39 ec 0f 83 cb 00 00 00 e8 1a dc 25 fa 48 8b 44 24 10 80 38 00 0f 85 9a 06 00 00 49 8b 07 48 89 c2 48 c1 ea 03 <42> 80 3c 32 00 0f 85 6e 06 00 00 48 8b 10 48 8d 78 28 49 89 17 48
> RSP: 0018:ffffc90001187310 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff87504776 RDI: 0000000000000003
> RBP: ffffc900011874e0 R08: 0000000000000400 R09: 0000000000000001
> R10: ffffffff875046d6 R11: 0000000000000000 R12: 0000000000000400
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888071660000
> FS:  0000555556b21300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9c09885040 CR3: 0000000021c77000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  dev_qdisc_enqueue+0x40/0x300 net/core/dev.c:3771
>  __dev_xmit_skb net/core/dev.c:3855 [inline]
>  __dev_queue_xmit+0x1f0e/0x36e0 net/core/dev.c:4170
>  __bpf_tx_skb net/core/filter.c:2114 [inline]
>  __bpf_redirect_no_mac net/core/filter.c:2139 [inline]
>  __bpf_redirect+0x5ba/0xd20 net/core/filter.c:2162
>  ____bpf_clone_redirect net/core/filter.c:2429 [inline]
>  bpf_clone_redirect+0x2ae/0x420 net/core/filter.c:2401
>  ___bpf_prog_run+0x3592/0x77d0 kernel/bpf/core.c:1548
>  __bpf_prog_run512+0x91/0xd0 kernel/bpf/core.c:1776
>  bpf_dispatcher_nop_func include/linux/bpf.h:718 [inline]
>  __bpf_prog_run include/linux/filter.h:624 [inline]
>  bpf_prog_run include/linux/filter.h:631 [inline]
>  bpf_test_run+0x37c/0xa20 net/bpf/test_run.c:119
>  bpf_prog_test_run_skb+0xa7c/0x1cb0 net/bpf/test_run.c:662
>  bpf_prog_test_run kernel/bpf/syscall.c:3307 [inline]
>  __sys_bpf+0x2137/0x5df0 kernel/bpf/syscall.c:4605
>  __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fef7c1e24d9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc95c98158 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fef7c1e24d9
> RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
> RBP: 00007fef7c1a64c0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fef7c1a6550
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 0597f54336b28fa4 ]---
> RIP: 0010:dequeue_head net/sched/sch_fq_codel.c:120 [inline]
> RIP: 0010:fq_codel_drop net/sched/sch_fq_codel.c:168 [inline]
> RIP: 0010:fq_codel_enqueue+0x83e/0x10c0 net/sched/sch_fq_codel.c:230
> Code: f8 e2 25 fa 45 39 ec 0f 83 cb 00 00 00 e8 1a dc 25 fa 48 8b 44 24 10 80 38 00 0f 85 9a 06 00 00 49 8b 07 48 89 c2 48 c1 ea 03 <42> 80 3c 32 00 0f 85 6e 06 00 00 48 8b 10 48 8d 78 28 49 89 17 48
> RSP: 0018:ffffc90001187310 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff87504776 RDI: 0000000000000003
> RBP: ffffc900011874e0 R08: 0000000000000400 R09: 0000000000000001
> R10: ffffffff875046d6 R11: 0000000000000000 R12: 0000000000000400
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888071660000
> FS:  0000555556b21300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9c09885040 CR3: 0000000021c77000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	f8                   	clc
>    1:	e2 25                	loop   0x28
>    3:	fa                   	cli
>    4:	45 39 ec             	cmp    %r13d,%r12d
>    7:	0f 83 cb 00 00 00    	jae    0xd8
>    d:	e8 1a dc 25 fa       	callq  0xfa25dc2c
>   12:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
>   17:	80 38 00             	cmpb   $0x0,(%rax)
>   1a:	0f 85 9a 06 00 00    	jne    0x6ba
>   20:	49 8b 07             	mov    (%r15),%rax
>   23:	48 89 c2             	mov    %rax,%rdx
>   26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	42 80 3c 32 00       	cmpb   $0x0,(%rdx,%r14,1) <-- trapping instruction
>   2f:	0f 85 6e 06 00 00    	jne    0x6a3
>   35:	48 8b 10             	mov    (%rax),%rdx
>   38:	48 8d 78 28          	lea    0x28(%rax),%rdi
>   3c:	49 89 17             	mov    %rdx,(%r15)
>   3f:	48                   	rex.W
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

This is the bug I mentioned in https://marc.info/?l=linux-netdev&m=163552087226957&w=2


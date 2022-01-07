Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6AE487A51
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbiAGQ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348240AbiAGQ1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:27:49 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27BCC06173E;
        Fri,  7 Jan 2022 08:27:48 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c2so5583037pfc.1;
        Fri, 07 Jan 2022 08:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OrXHzwsQEzApYAb08/vgr/iOHUJBZcv9FRHsGwpb498=;
        b=i3fTnUvhY06ZcPs+HMvpfS5zHX7agZRWvHdsTwTl1TkL2GOuFKrYHRjsqymJdUFwdC
         4zMNL1r/l5EsQMPrzHYEK4HCmNjWiRdEiM8b0vPCXdH2zFTHBzsBXRi6zzPOcCjGj6u9
         ghz6mT4vlXaNrerpTP5/Vm/E6EbTJTG9EVeZFxSaeBwdnHIe7T3Xy7yEdPdFRHBoVwrd
         A7a/LbGJqm8Geg6hldftvJjXnalsXkts9v6HJrYZ4GSnuwxCEXIzIiUIolFYVNtyQKqy
         m/FJ9kYbtYjTfG1lOsAW7ajVu2XduaCgmbLM9XpEjJwDgtSGLyhBtTeq0DG8LMPayJGk
         QxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OrXHzwsQEzApYAb08/vgr/iOHUJBZcv9FRHsGwpb498=;
        b=ZN91GUcUyCxTKEd4gWyhN9lLMuJrpHGh2AzugVp2cK9J1zqi/I0g4fWRYYzeheWSzn
         kSHCrTcFTVs1urJsSIF87WkONRWGrwb23XgULHEaRh8Jvczde4ZGkdPYSvPCpiQIYN4V
         cma1h0U7kOo9tC16DJ40QmBKZeip3FNWwn4S//lnncbeFEpg7GQfPVFLKnsU7EnkpMXm
         RWvHGWaeQk8FtzsB81bunlFsE3eHtUrZwnFUa2Gd/bW755f0IezB4i4d1nXGSLE6Qlxj
         exPJRySH6oFf7/MQUK3PBigDpfhRbTr3fJS8FEzrZXzIzP3YFBEsqIoxnAWnvxCEAhYN
         cj4g==
X-Gm-Message-State: AOAM530jABsEf85cfhQB3WYjZ3rygrfxBMQ9WAJ9wRqZugXGBcEctwxw
        XZqJ57Lg7hwdPOynO7JD93Z2F2ZILKo/2gxZMpA=
X-Google-Smtp-Source: ABdhPJzNM8P/vPaXr4QbCREfthoANHoIqq5NUUR5uPMjknD9QyIBJ46ngS7OoP8j6eGWJNPaUCkH33Zlse0Yz5loNAA=
X-Received: by 2002:aa7:8c59:0:b0:4bc:9dd2:6c12 with SMTP id
 e25-20020aa78c59000000b004bc9dd26c12mr25922525pfd.59.1641572868290; Fri, 07
 Jan 2022 08:27:48 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab9b3e05d4feacd6@google.com>
In-Reply-To: <000000000000ab9b3e05d4feacd6@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Jan 2022 08:27:37 -0800
Message-ID: <CAADnVQLH5r-OLfGwduMqvTuz952Y+D7X29bW-f8QGpE9G6dF6g@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in dev_get_by_index_rcu (2)
To:     syzbot <syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke, Jesper,

please take a look.
Seems to be in your area of expertise.

Thanks

On Fri, Jan 7, 2022 at 6:19 AM syzbot
<syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    819d11507f66 bpf, selftests: Fix spelling mistake "tained"..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=12500db3b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=22b66456935ee10
> dashboard link: https://syzkaller.appspot.com/bug?extid=983941aa85af6ded1fd9
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153a6cb3b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121c690bb00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc000000003e: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000001f0-0x00000000000001f7]
> CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:dev_index_hash net/core/dev.c:222 [inline]
> RIP: 0010:dev_get_by_index_rcu+0x28/0x140 net/core/dev.c:885
> Code: 00 00 41 55 41 54 55 89 f5 53 48 89 fb e8 00 9d 4d fa 48 8d bb f0 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 fc 00 00 00 48 8b 93 f0 01 00 00 40 0f b6 c5 48
> RSP: 0018:ffffc90000d97608 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
> RDX: 000000000000003e RSI: ffffffff872a14d0 RDI: 00000000000001f0
> RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff873745ad R11: 000000000008808a R12: ffff88806a062100
> R13: 0000000000000003 R14: ffff88806a062100 R15: ffffc90001116000
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055555733a848 CR3: 000000001479e000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ____bpf_clone_redirect net/core/filter.c:2410 [inline]
>  bpf_clone_redirect+0x91/0x420 net/core/filter.c:2401
>  bpf_prog_bebbfe2050753572+0x56/0xcc0
>  __bpf_prog_run include/linux/filter.h:626 [inline]
>  bpf_prog_run_xdp include/linux/filter.h:801 [inline]
>  veth_xdp_rcv_skb+0x64b/0x1b20 drivers/net/veth.c:775
>  veth_xdp_rcv+0x3ac/0x810 drivers/net/veth.c:881
>  veth_poll+0x134/0x850 drivers/net/veth.c:913
>  __napi_poll+0xaf/0x440 net/core/dev.c:7023
>  napi_poll net/core/dev.c:7090 [inline]
>  net_rx_action+0x801/0xb40 net/core/dev.c:7177
>  __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
>  run_ksoftirqd kernel/softirq.c:921 [inline]
>  run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
>  smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
>  kthread+0x405/0x4f0 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> Modules linked in:
> ---[ end trace 86b7d5782a67ad32 ]---
> RIP: 0010:dev_index_hash net/core/dev.c:222 [inline]
> RIP: 0010:dev_get_by_index_rcu+0x28/0x140 net/core/dev.c:885
> Code: 00 00 41 55 41 54 55 89 f5 53 48 89 fb e8 00 9d 4d fa 48 8d bb f0 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 fc 00 00 00 48 8b 93 f0 01 00 00 40 0f b6 c5 48
> RSP: 0018:ffffc90000d97608 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
> RDX: 000000000000003e RSI: ffffffff872a14d0 RDI: 00000000000001f0
> RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff873745ad R11: 000000000008808a R12: ffff88806a062100
> R13: 0000000000000003 R14: ffff88806a062100 R15: ffffc90001116000
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055555733a848 CR3: 000000001479e000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:   00 00                   add    %al,(%rax)
>    2:   41 55                   push   %r13
>    4:   41 54                   push   %r12
>    6:   55                      push   %rbp
>    7:   89 f5                   mov    %esi,%ebp
>    9:   53                      push   %rbx
>    a:   48 89 fb                mov    %rdi,%rbx
>    d:   e8 00 9d 4d fa          callq  0xfa4d9d12
>   12:   48 8d bb f0 01 00 00    lea    0x1f0(%rbx),%rdi
>   19:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   20:   fc ff df
>   23:   48 89 fa                mov    %rdi,%rdx
>   26:   48 c1 ea 03             shr    $0x3,%rdx
> * 2a:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   2e:   0f 85 fc 00 00 00       jne    0x130
>   34:   48 8b 93 f0 01 00 00    mov    0x1f0(%rbx),%rdx
>   3b:   40 0f b6 c5             movzbl %bpl,%eax
>   3f:   48                      rex.W
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

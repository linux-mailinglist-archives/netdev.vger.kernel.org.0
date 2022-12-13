Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10E564B5EF
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 14:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiLMNST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 08:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiLMNSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 08:18:18 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803531FF8D
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 05:18:16 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3bf4ade3364so190936897b3.3
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 05:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J08FU6Ej3Zl/anpD6Zp9iqfuxgMGV3CwTxE/dEbaErE=;
        b=IymbFqPZCO6zWMwRbx/kn/j91EFOda0x/j/2kjVD3iwIq9EYHenJbpVYtC4gi7wLrM
         gv/rqZjdENtDru+sas4xkE9y4O+SjBjIwgYHuhOsLH2lwPsZwM2if06brag57Pz2BIDS
         Jw/BYrBfoLwnGZCHBsb/9jk/JVDyUdsB0SGIpreSSXHDMJzhAv3zGkFJy4GBcqSS6XHL
         xeU71TNbUmNkJcWRMdWh1yv+wUnYojTolsiK+HGzKT3+NOd/u5HkSuKDIwChjjppbxH7
         Me3+RLxL3v3ZYVHkXt5+a61Iz18J2YT6dpvUqwmxdi7q+bjip6VXKACClsbi/vTTf239
         +K9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J08FU6Ej3Zl/anpD6Zp9iqfuxgMGV3CwTxE/dEbaErE=;
        b=IufU50OfA/Fvmz/g8Pdvb9YP9HuyNVTY//IBSqQXvLH0eHKf3znpc5aVNxEbGqQH/f
         t4NjjY08/cqe2TCxwIvkIzixPPh8zRLhsGGa71Y7vobgUCbl7dNmu76DnShRUWp3czb8
         7p+09ZqM3FhtpvPTQzGLWYfl+sbTktNsQ0GKYh5Dc4GeBoU66UlVii9n/bosMvaeVT+x
         YzwwWL+EN7PjgVvUVC+KSWQDfvu0Yn4sy/BwhocZEDIgqszcG43/OoaknOfejhoUjaZj
         rtulrLhTLEZ5vOtUNyF58l9JlDPIFjVe0WarrJf5w4LBg4h1f+7OkqgLcYy7bE//btVV
         k5WA==
X-Gm-Message-State: ANoB5plU4ZlzUdmNm4t/izXC+CBRjCBvYydJrjWVH8HdT2RnYLYIJznb
        zl92yU3jE+Oe8jOqAlzGq8sDND3tZ4lD8wzheFdpOA==
X-Google-Smtp-Source: AA0mqf7ESHWgS6RZte1WLbUbv4pGX5qj4UxdBSdjJrkkke2ucyMOZmymvuGl4DNoBCgkNu6O4w5mmHuM8bTw1xSr+X0=
X-Received: by 2002:a81:d87:0:b0:393:ab0b:5a31 with SMTP id
 129-20020a810d87000000b00393ab0b5a31mr25184781ywn.55.1670937494834; Tue, 13
 Dec 2022 05:18:14 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrffvqv1TrMO2A9rmysq4QrGcn8PdrzNWpLDjP_u_3U-7Cw@mail.gmail.com>
In-Reply-To: <CAO4mrffvqv1TrMO2A9rmysq4QrGcn8PdrzNWpLDjP_u_3U-7Cw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 13 Dec 2022 14:18:03 +0100
Message-ID: <CANn89iKWUraHz8LL_nWFEaGTS7HFYn2GtmAJBky55n9Q1=kYsw@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in tcp_write_wakeup
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        bpf@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 2:11 PM Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developers,
>
> Recently, when using our tool to fuzz kernel, the following crash was triggered.
>
> HEAD commit: 76dcd734eca
> git tree: linux-next
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1mHUUrG4QFkrmP3xw7QgiytT7xWE6lbPy/view?usp=share_link
> kernel config: https://drive.google.com/file/d/1jH4qV5XblPADvMDUlvS7DwtW0FroMoVB/view?usp=share_link
>
> Unfortunately, I do not have a reproducer for this crash. My manual
> investigation found that the value of %rax may be invalid. When adding
> statistics to net_statistics of the current network namespace, the
> value of net->mib (which is %rax) is invalid. I'm wondering if sk or
> net is freed, which causes an invalid address of mib.

We have plenty of syzbot reports about this really.

We are waiting for a reproducer...


>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
>
> BUG: unable to handle page fault for address: ffff88800167981d
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0003) - permissions violation
> PGD 7201067 P4D 7201067 PUD 7202067 PMD 80000000016001e1
> Oops: 0003 [#1] PREEMPT SMP
> CPU: 0 PID: 1425 Comm: systemd-udevd Not tainted 6.1.0-rc8 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:tcp_xmit_probe_skb net/ipv4/tcp_output.c:4024 [inline]
> RIP: 0010:tcp_write_wakeup+0x450/0x710 net/ipv4/tcp_output.c:4078
> Code: fd 44 89 6d 2c 49 8d 7c 24 30 e8 9b 93 49 fd 49 8b 5c 24 30 48
> 8d bb c8 01 00 00 e8 8a 93 49 fd 48 8b 83 c8 01 00 00 49 63 cf <65> 48
> ff 04 c8 49 8d bc 24 90 05 00 00 e8 ee 8e 49 fd 45 8b 84 24
> RSP: 0018:ffffc90000003cb8 EFLAGS: 00010246
> RAX: ffffffff83a794b5 RBX: ffff88800bbe8040 RCX: 000000000000006d
> RDX: 0000000000000855 RSI: 0000000000000000 RDI: ffff88800bbe8208
> RBP: ffff88800bb1a000 R08: 000188800bbe820f R09: 0000000000000000
> R10: 0001ffffffffffff R11: 000188800bb1a02c R12: ffff8880368d00c0
> R13: 00000000ffffffff R14: ffff88800bb1a028 R15: 000000000000006d
> FS:  00007fa45b07c8c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88800167981d CR3: 000000000ac20000 CR4: 00000000003506f0
> Call Trace:
>  <IRQ>
>  tcp_send_probe0+0x2c/0x2b0 net/ipv4/tcp_output.c:4093
>  tcp_probe_timer net/ipv4/tcp_timer.c:393 [inline]
>  tcp_write_timer_handler+0x322/0x4c0 net/ipv4/tcp_timer.c:624
>  tcp_write_timer+0xb9/0x160 net/ipv4/tcp_timer.c:637
>  call_timer_fn+0x2e/0x240 kernel/time/timer.c:1474
>  expire_timers+0x116/0x240 kernel/time/timer.c:1519
>  __run_timers+0x368/0x410 kernel/time/timer.c:1790
>  run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1803
>  __do_softirq+0xf2/0x2c9 kernel/softirq.c:571
>  __irq_exit_rcu kernel/softirq.c:650 [inline]
>  irq_exit_rcu+0x41/0x70 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x8d/0xb0 arch/x86/kernel/apic/apic.c:1107
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
> RIP: 0010:check_kcov_mode kernel/kcov.c:173 [inline]
> RIP: 0010:write_comp_data kernel/kcov.c:236 [inline]
> RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x14/0xa0 kernel/kcov.c:304
> Code: 12 4d 89 44 fa 18 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
> 00 4c 8b 04 24 65 48 8b 14 25 80 ac 01 00 65 8b 05 04 22 da 7e <a9> 00
> 01 ff 00 74 10 a9 00 01 00 00 74 6e 83 ba c4 0a 00 00 00 74
> RSP: 0018:ffffc9000059ba10 EFLAGS: 00000246
> RAX: 0000000080000000 RBX: ffff8880090653c0 RCX: 0000000000000000
> RDX: ffff888009b60e80 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff818fa64f R09: ffffc9000059ba30
> R10: 0001ffffffffffff R11: 00018880095f63f0 R12: 0000000000000001
> R13: ffff8880095f63a8 R14: 0000000000000000 R15: ffff8880095f63a8
>  selinux_inode_permission+0x6f/0x400 security/selinux/hooks.c:3073
>  security_inode_permission+0x72/0xc0 security/security.c:1326
>  inode_permission+0xc5/0x460 fs/namei.c:533
>  may_lookup fs/namei.c:1715 [inline]
>  link_path_walk+0x1b2/0x7e0 fs/namei.c:2262
>  path_lookupat+0x8b/0x3c0 fs/namei.c:2473
>  filename_lookup+0x133/0x310 fs/namei.c:2503
>  vfs_statx+0xa3/0x460 fs/stat.c:229
>  vfs_fstatat fs/stat.c:267 [inline]
>  vfs_lstat include/linux/fs.h:3304 [inline]
>  __do_sys_newlstat fs/stat.c:423 [inline]
>  __se_sys_newlstat+0x6c/0x270 fs/stat.c:417
>  __x64_sys_newlstat+0x2d/0x40 fs/stat.c:417
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fa459eef335
> Code: 69 db 2b 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00
> 83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6 b8 06 00 00 00 0f 05 <48> 3d
> 00 f0 ff ff 77 03 f3 c3 90 48 8b 15 31 db 2b 00 f7 d8 64 89
> RSP: 002b:00007ffeff53e148 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
> RAX: ffffffffffffffda RBX: 000055cd6b8d7780 RCX: 00007fa459eef335
> RDX: 00007ffeff53e180 RSI: 00007ffeff53e180 RDI: 000055cd6b8d6780
> RBP: 00007ffeff53e240 R08: 00007fa45a1ae248 R09: 0000000000001010
> R10: 0000000000000020 R11: 0000000000000246 R12: 000055cd6b8d6780
> R13: 000055cd6b8d67a0 R14: 000055cd6b8cabbb R15: 000055cd6b8cabc0
>  </TASK>
> Modules linked in:
> CR2: ffff88800167981d
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:tcp_xmit_probe_skb net/ipv4/tcp_output.c:4024 [inline]
> RIP: 0010:tcp_write_wakeup+0x450/0x710 net/ipv4/tcp_output.c:4078
> Code: fd 44 89 6d 2c 49 8d 7c 24 30 e8 9b 93 49 fd 49 8b 5c 24 30 48
> 8d bb c8 01 00 00 e8 8a 93 49 fd 48 8b 83 c8 01 00 00 49 63 cf <65> 48
> ff 04 c8 49 8d bc 24 90 05 00 00 e8 ee 8e 49 fd 45 8b 84 24
> RSP: 0018:ffffc90000003cb8 EFLAGS: 00010246
> RAX: ffffffff83a794b5 RBX: ffff88800bbe8040 RCX: 000000000000006d
> RDX: 0000000000000855 RSI: 0000000000000000 RDI: ffff88800bbe8208
> RBP: ffff88800bb1a000 R08: 000188800bbe820f R09: 0000000000000000
> R10: 0001ffffffffffff R11: 000188800bb1a02c R12: ffff8880368d00c0
> R13: 00000000ffffffff R14: ffff88800bb1a028 R15: 000000000000006d
> FS:  00007fa45b07c8c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88800167981d CR3: 000000000ac20000 CR4: 00000000003506f0
> ----------------
> Code disassembly (best guess):
>    0: fd                   std
>    1: 44 89 6d 2c           mov    %r13d,0x2c(%rbp)
>    5: 49 8d 7c 24 30       lea    0x30(%r12),%rdi
>    a: e8 9b 93 49 fd       callq  0xfd4993aa
>    f: 49 8b 5c 24 30       mov    0x30(%r12),%rbx
>   14: 48 8d bb c8 01 00 00 lea    0x1c8(%rbx),%rdi
>   1b: e8 8a 93 49 fd       callq  0xfd4993aa
>   20: 48 8b 83 c8 01 00 00 mov    0x1c8(%rbx),%rax
>   27: 49 63 cf             movslq %r15d,%rcx
> * 2a: 65 48 ff 04 c8       incq   %gs:(%rax,%rcx,8) <-- trapping instruction
>   2f: 49 8d bc 24 90 05 00 lea    0x590(%r12),%rdi
>   36: 00
>   37: e8 ee 8e 49 fd       callq  0xfd498f2a
>   3c: 45                   rex.RB
>   3d: 8b                   .byte 0x8b
>   3e: 84                   .byte 0x84
>   3f: 24                   .byte 0x24
>
> Best,
> Wei

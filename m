Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E54B4DA9
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350643AbiBNLSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:18:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbiBNLSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:18:17 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF326580B;
        Mon, 14 Feb 2022 02:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a1wQghG90lx81o8SG78KOxd3bPJKs8QOxjfYqgzz1rA=; b=YQQk3C53tohPEnubJcPR9y1WnI
        Ts0n+6Ax0oh4B4vsQ7q+xznpVSxMNdFE4Q5cnzYOujsffffOKpZDuYzsuuS2zDjI4fz6bxoPdLlEp
        hKry49mMucHKNtGBFPvCvcK9rr4YV+5Rgzt1cUSeSKbIKMRUkRcammQTnuup4qJn6IzO8fNbrKfNA
        IQhkfFUHHwDQpgSHipyOFH1mB6MQ4fxtTDYnuqya8/NsfU9CrSwES71EuERf4X3rDzYTHpAJC3pwu
        4RUxq4S0qQPXgy0c8LjrHV/Qk/mOgrGZVrqlFaEKCE2116C9RXxln/g8uUiQ7DxvGULdnYwntV1Sx
        E5jDIK3g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJYwY-009tAD-IF; Mon, 14 Feb 2022 10:50:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 91E4F3002C5;
        Mon, 14 Feb 2022 11:50:52 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 70D052025FC40; Mon, 14 Feb 2022 11:50:52 +0100 (CET)
Date:   Mon, 14 Feb 2022 11:50:52 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jgross@suse.com, jpoimboe@redhat.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        x86@kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>
Subject: Re: [syzbot] kernel BUG in __text_poke
Message-ID: <Ygo0DBn/uZyKwtbt@hirez.programming.kicks-ass.net>
References: <0000000000007646bd05d7f81943@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000007646bd05d7f81943@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Song..

On Mon, Feb 14, 2022 at 02:44:22AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f95f768f0af4 bpf, x86_64: Fail gracefully on bpf_jit_binar..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13fb08c2700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=87f65c75f4a72db05445
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kernel/alternative.c:989!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 12993 Comm: syz-executor.1 Not tainted 5.16.0-syzkaller-11632-gf95f768f0af4 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__text_poke+0x343/0x8c0 arch/x86/kernel/alternative.c:989
> Code: c3 0f 86 2c fe ff ff 49 8d bc 24 00 10 00 00 e8 43 be 88 00 48 89 44 24 28 48 85 db 74 0c 48 83 7c 24 28 00 0f 85 1b fe ff ff <0f> 0b 48 b8 00 f0 ff ff ff ff 0f 00 49 21 c0 48 85 db 0f 85 c6 02
> RSP: 0018:ffffc90005e6f7a8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88807d1c8000 RSI: ffffffff81b3c443 RDI: 0000000000000003
> RBP: 0000000000000080 R08: 0000000000000000 R09: ffffc90005e6f7bf
> R10: ffffffff81b3c3e1 R11: 0000000000000001 R12: ffffffffa0010e00
> R13: 0000000000000080 R14: 0000000000000e80 R15: 0000000000002000
> FS:  00007fd60b1d8700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9329383090 CR3: 000000007c3bb000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Call Trace:
>  <TASK>
>  text_poke_copy+0x66/0xa0 arch/x86/kernel/alternative.c:1132
>  bpf_arch_text_copy+0x21/0x40 arch/x86/net/bpf_jit_comp.c:2426
>  bpf_jit_binary_pack_finalize+0x43/0x170 kernel/bpf/core.c:1094
>  bpf_int_jit_compile+0x9d5/0x12f0 arch/x86/net/bpf_jit_comp.c:2383
>  bpf_prog_select_runtime+0x4d4/0x8a0 kernel/bpf/core.c:2159
>  bpf_prog_load+0xfe6/0x2250 kernel/bpf/syscall.c:2349
>  __sys_bpf+0x68a/0x59a0 kernel/bpf/syscall.c:4640
>  __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fd60c863059
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd60b1d8168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fd60c975f60 RCX: 00007fd60c863059
> RDX: 0000000000000048 RSI: 0000000020000200 RDI: 0000000000000005
> RBP: 00007fd60c8bd08d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffec77d82ef R14: 00007fd60b1d8300 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__text_poke+0x343/0x8c0 arch/x86/kernel/alternative.c:989
> Code: c3 0f 86 2c fe ff ff 49 8d bc 24 00 10 00 00 e8 43 be 88 00 48 89 44 24 28 48 85 db 74 0c 48 83 7c 24 28 00 0f 85 1b fe ff ff <0f> 0b 48 b8 00 f0 ff ff ff ff 0f 00 49 21 c0 48 85 db 0f 85 c6 02
> RSP: 0018:ffffc90005e6f7a8 EFLAGS: 00010246
> 
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88807d1c8000 RSI: ffffffff81b3c443 RDI: 0000000000000003
> RBP: 0000000000000080 R08: 0000000000000000 R09: ffffc90005e6f7bf
> R10: ffffffff81b3c3e1 R11: 0000000000000001 R12: ffffffffa0010e00
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
